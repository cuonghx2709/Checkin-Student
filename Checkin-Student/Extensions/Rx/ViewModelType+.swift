//
//  ViewModelType+.swift
//  fGoal
//
//  Created by Phạm Xuân Tiến on 3/23/19.
//  Copyright © 2019 Sun*. All rights reserved.
//

extension ViewModelType {
    func validate<T>(object: Driver<T>,
                     trigger: Driver<Void>,
                     validator: @escaping (T) -> ValidationResult) -> Driver<ValidationResult> {
        return Driver.combineLatest(object, trigger)
            .map { $0.0 }
            .map { validator($0) }
//            .startWith(.invalid([ValidationError.empty]))
    }
    
    func checkIfDataIsEmpty<T: Collection>(fetchItemsTrigger: Driver<Void>,
                                           loadTrigger: Driver<Bool>,
                                           items: Driver<T>) -> Driver<Bool> {
        return Driver.combineLatest(fetchItemsTrigger, loadTrigger)
            .map { $0.1 }
            .withLatestFrom(items) { ($0, $1.isEmpty) }
            .map { loading, isEmpty -> Bool in
                if loading { return false }
                return isEmpty
            }
    }
}

extension ViewModelType {
    func setupTable<T>(loadTrigger: Driver<Void>,
                       getItems: @escaping () -> Observable<[T]>,
                       refreshTrigger: Driver<Void>,
                       refreshItems: @escaping () -> Observable<[T]>)
        ->
        // swiftlint:disable:next large_tuple
        (items: PublishSubject<[T]>,
        fetchItems: Driver<Void>,
        error: Driver<Error>,
        loading: Driver<Bool>,
        refreshing: Driver<Bool>,
        errorTracker: ErrorTracker,
        loadingIndicator: ActivityIndicator) {
            
            return setupTableWithParam(
                loadTrigger: loadTrigger,
                getItems: { _ in
                    return getItems()
                },
                refreshTrigger: refreshTrigger,
                refreshItems: { _ in
                    return refreshItems()
                })
    }
    
    func setupTableWithParam<T, U>(loadTrigger: Driver<U>,
                                   getItems: @escaping (U) -> Observable<[T]>,
                                   refreshTrigger: Driver<U>,
                                   refreshItems: @escaping (U) -> Observable<[T]>)
        ->
        // swiftlint:disable:next large_tuple
        (items: PublishSubject<[T]>,
        fetchItems: Driver<Void>,
        error: Driver<Error>,
        loading: Driver<Bool>,
        refreshing: Driver<Bool>,
        errorTracker: ErrorTracker,
        loadingIndicator: ActivityIndicator) {
            
            let dataSubject = PublishSubject<[T]>()
            let errorTracker = ErrorTracker()
            let error = errorTracker.asDriver()
            let refreshingActivityIndicator = ActivityIndicator()
            let refreshing = refreshingActivityIndicator.asDriver()
            let loadingActivityIndicator = ActivityIndicator()
            let loading = loadingActivityIndicator.asDriver()
            
            let loadingOrRefresh = Driver.merge(loading, refreshing)
                .startWith(false)
            
            let loadItems = loadTrigger
                .withLatestFrom(loadingOrRefresh) {
                    (arg: $0, loading: $1)
                }
                .filter { !$0.loading }
                .map { $0.arg }
                .flatMapLatest { arg in
                    getItems(arg)
                        .trackError(errorTracker)
                        .trackActivity(loadingActivityIndicator)
                        .asDriverOnErrorJustComplete()
                }
                .do(onNext: { data in
                    dataSubject.onNext(data)
                })
                .mapToVoid()
            
            let refreshItems = refreshTrigger
                .withLatestFrom(loadingOrRefresh) {
                    (arg: $0, loading: $1)
                }
                .filter { !$0.loading }
                .map { $0.arg }
                .flatMapLatest { arg in
                    refreshItems(arg)
                        .trackError(errorTracker)
                        .trackActivity(refreshingActivityIndicator)
                        .asDriverOnErrorJustComplete()
                }
                .do(onNext: { page in
                    dataSubject.onNext(page)
                })
                .mapToVoid()
            
            let fetchItems = Driver.merge(loadItems, refreshItems)
            
            return (dataSubject,
                    fetchItems,
                    error,
                    loading,
                    refreshing,
                    errorTracker,
                    loadingActivityIndicator
            )
    }
    // swiftlint:disable function_parameter_count
    func setupLoadMoreTable<T, V>(loadTrigger: Driver<Void>,
                                  getItems: @escaping () -> Observable<PagingInfo<T>>,
                                  refreshTrigger: Driver<Void>,
                                  refreshItems: @escaping () -> Observable<PagingInfo<T>>,
                                  loadMoreTrigger: Driver<Void>,
                                  loadMoreItems: @escaping (Int) -> Observable<PagingInfo<T>>,
                                  mapper: @escaping (T) -> V)
        ->
        // swiftlint:disable:next large_tuple
        (page: BehaviorRelay<PagingInfo<V>>,
        fetchItems: Driver<Void>,
        error: Driver<Error>,
        loading: Driver<Bool>,
        refreshing: Driver<Bool>,
        loadingMore: Driver<Bool>) {
            return setupLoadMoreTableWithParam(
                loadTrigger: loadTrigger,
                getItems: { _  in
                    return getItems()
                },
                refreshTrigger: refreshTrigger,
                refreshItems: { _ in
                    return refreshItems()
                },
                loadMoreTrigger: loadMoreTrigger,
                loadMoreItems: { (_, page) in
                    return loadMoreItems(page)
                },
                mapper: mapper)
    }
    
    //swiftlint:disable function_parameter_count
    func setupLoadMoreTableWithParam<T, U, V>(loadTrigger: Driver<U>,
                                              getItems: @escaping (U) -> Observable<PagingInfo<T>>,
                                              refreshTrigger: Driver<U>,
                                              refreshItems: @escaping (U) -> Observable<PagingInfo<T>>,
                                              loadMoreTrigger: Driver<U>,
                                              loadMoreItems: @escaping (U, Int) -> Observable<PagingInfo<T>>,
                                              mapper: @escaping (T) -> V)
        ->
        // swiftlint:disable:next large_tuple
        (page: BehaviorRelay<PagingInfo<V>>,
        fetchItems: Driver<Void>,
        error: Driver<Error>,
        loading: Driver<Bool>,
        refreshing: Driver<Bool>,
        loadingMore: Driver<Bool>) {
            
            let pageSubject = BehaviorRelay<PagingInfo<V>>(value: PagingInfo<V>(page: 1, items: []))
            let errorTracker = ErrorTracker()
            let loadingActivityIndicator = ActivityIndicator()
            let refreshingActivityIndicator = ActivityIndicator()
            let loadingMoreActivityIndicator = ActivityIndicator()
            
            let loading = loadingActivityIndicator.asDriver()
            let refreshing = refreshingActivityIndicator.asDriver()
            let loadingMoreSubject = PublishSubject<Bool>()
            let loadingMore = Driver.merge(loadingMoreActivityIndicator.asDriver(),
                                           loadingMoreSubject.asDriverOnErrorJustComplete())
            
            let loadingOrLoadingMore = Driver.merge(loading, refreshing, loadingMore)
                .startWith(false)
            
            let loadItems = loadTrigger
                .withLatestFrom(loadingOrLoadingMore) {
                    (arg: $0, loading: $1)
                }
                .filter { !$0.loading }
                .map { $0.arg }
                .flatMapLatest { arg in
                    getItems(arg)
                        .trackError(errorTracker)
                        .trackActivity(loadingActivityIndicator)
                        .asDriverOnErrorJustComplete()
                }
                .do(onNext: { page in
                    let newPage = PagingInfo<V>(page: page.page,
                                                items: page.items.map(mapper),
                                                hasMorePages: page.hasMorePages)
                    pageSubject.accept(newPage)
                })
                .mapToVoid()
            
            let refreshItems = refreshTrigger
                .withLatestFrom(loadingOrLoadingMore) {
                    (arg: $0, loading: $1)
                }
                .filter { !$0.loading }
                .map { $0.arg }
                .flatMapLatest { arg in
                    refreshItems(arg)
                        .trackError(errorTracker)
                        .trackActivity(refreshingActivityIndicator)
                        .asDriverOnErrorJustComplete()
                }
                .do(onNext: { page in
                    let newPage = PagingInfo<V>(page: page.page,
                                                items: page.items.map(mapper),
                                                hasMorePages: page.hasMorePages)
                    pageSubject.accept(newPage)
                })
                .mapToVoid()
            
            let loadMoreItems = loadMoreTrigger
                .withLatestFrom(loadingOrLoadingMore) {
                    (arg: $0, loading: $1)
                }
                .filter { !$0.loading }
                .map { $0.arg }
                .do(onNext: { _ in
                    if pageSubject.value.items.isEmpty || !pageSubject.value.hasMorePages {
                        loadingMoreSubject.onNext(false)
                    }
                })
                .filter { _ in
                    !pageSubject.value.items.isEmpty && pageSubject.value.hasMorePages
                }
                .flatMapLatest { arg -> Driver<PagingInfo<T>> in
                    let page = pageSubject.value.page
                    return loadMoreItems(arg, page + 1)
                        .trackError(errorTracker)
                        .trackActivity(loadingMoreActivityIndicator)
                        .asDriverOnErrorJustComplete()
                }
                .filter { !$0.items.isEmpty }
                .do(onNext: { page in
                    let currentPage = pageSubject.value
                    let items = currentPage.items + page.items.map(mapper)
                    let newPage = PagingInfo<V>(page: page.page,
                                                items: items,
                                                hasMorePages: page.hasMorePages)
                    pageSubject.accept(newPage)
                })
                .mapToVoid()
            
            let fetchItems = Driver.merge(loadItems, refreshItems, loadMoreItems)
            return (pageSubject,
                    fetchItems,
                    errorTracker.asDriver(),
                    loading,
                    refreshing,
                    loadingMore)
    }
}
