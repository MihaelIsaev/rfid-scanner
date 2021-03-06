import Foundation
import SwiftyGPIO

protocol ButtonDelegate: AnyObject {
    func buttonDidPush(_ button: Button)
}

class Button {
    
    let gpio: GPIO
    weak var delegate: ButtonDelegate?
    
    init(gpio: GPIO) {
        self.gpio = gpio
        
        gpio.direction = .IN
        gpio.value = 0
        gpio.bounceTime = 0.5
        gpio.onFalling { [weak self] _ in
            guard let self = self else { return }
            self.delegate?.buttonDidPush(self)
        }
    }
    
    func cleanup() {
        gpio.value = 0
        gpio.clearListeners()
        gpio.direction = .IN
    }
    
    deinit {
        cleanup()
    }
}
