import PlaygroundSupport
import PromiseKit

//enum MyErr : Error {
//    case error
//}

//Promise<Bool> { fulfill, reject, progress in
//    DispatchQueue.main.async {
//        for c in 0 ..< 10 {
//            progress(c)
//        }
//        fulfill(true)
//    }
//    //reject(MyErr.error)
//}.progress { value in
//    print(value)
//}.then { _ in
//    print("success!")
//}.catch { error in
//    print(error)
//}

Promise<Int> { globalFulfill, globalReject, globalProgress in
    Promise<Int> { fulfill, _, progress in
        DispatchQueue.main.async {
            for c in 0 ..< 10 {
                progress(c)
            }
            fulfill(10)
        }
    }
    .progress { value in
        globalProgress(value)
    }
    .then { value in
        return Promise<Int> { fulfill, _, progress in
            DispatchQueue.main.async {
                for c in 0 ..< 10 {
                    progress(value + c)
                }
                fulfill(value + 10)
            }
        }
        .progress { value in
            globalProgress(value)
        }
    }
    .then { value in
        globalFulfill(value)
    }
    .catch { error in
        globalReject(error)
    }
}
.progress { value in
    print(value as! Int + 1)
}
.catch { error in
}


//firstly {
//    Promise(value: 1)
//}.then { _ in
//    2
//}.then { _ in
//    3
//}.catch { error in
////     never happens!
//}.progress { value in
////     never happens!
//}

PlaygroundPage.current.needsIndefiniteExecution = true
