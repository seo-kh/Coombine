//
//  Subject.swift
//
//
//  Created by alphacircle on 10/15/24.
//

import Foundation

/// 요소(Element)를 발행하기 위해 외부 호출자에게 메소드를 제공하는 발행자(Publisher)
///
/// Subject는
public protocol _Subject<Output, Failure>: AnyObject, _Publisher {
    
    /// subscriber에게 값을 전송
    /// - Parameter value: 전송할 값
    func send(_ value: Self.Output)
    
    /// subscriber에게 구독권 전송
    /// - Parameter subscription: subscriber가 element를 요청할 수 있는 구독권 객체
    ///
    /// 이 함수는 새로운 상위 스트림 구독권(upstream subscription)에 요구사항을 전달하도록 ``Subject``에게 권한을 준다.
    func send(subscription: any _Subscription)
    
    /// subscriber에게 완료 신호 전송
    func send(completion: _Subscribers._Completion<Self.Failure>)
}

public extension _Subject {
    /// subscriber에게 void 값 전송
    func send() where Output == Void {
        self.send(())
    }
}
