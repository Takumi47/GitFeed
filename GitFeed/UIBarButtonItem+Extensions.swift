//
//  UIBarButtonItem+Extensions.swift
//  GitFeed
//
//  Created by xander on 2023/3/20.
//

import UIKit
import RxSwift
import RxCocoa

public extension Reactive where Base: UIBarButtonItem {
    var safeTap: ControlEvent<Void> {
        return ControlEvent.init(events: tap.throttle(.milliseconds(1500), latest: false, scheduler: MainScheduler.instance))
    }
    
    func asSafeDriver() -> Driver<()> {
        return self.safeTap
            .asControlEvent()
            .asDriver()
    }
}
