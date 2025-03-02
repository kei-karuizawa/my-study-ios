import UIKit

class CalculatorViewController: UIViewController {
    
    // MARK: - 属性
    private let displayLabel = UILabel()
    private let historyLabel = UILabel()
    private var currentInput = ""
    private var currentOperation: Operation?
    private var firstOperand: Double?
    private var secondOperand: Double?
    private var shouldResetInput = false
    private var isInScientificMode = true
    private var memory: Double = 0
    
    // MARK: - 生命周期方法
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - UI设置
    private func setupUI() {
        view.backgroundColor = .black
        
        // 设置显示标签
        setupDisplayLabels()
        
        // 创建按钮网格
        setupButtonGrid()
    }
    
    private func setupDisplayLabels() {
        // 历史标签
        historyLabel.translatesAutoresizingMaskIntoConstraints = false
        historyLabel.textColor = .lightGray
        historyLabel.textAlignment = .right
        historyLabel.font = UIFont.systemFont(ofSize: 24)
        historyLabel.text = ""
        view.addSubview(historyLabel)
        
        // 结果标签
        displayLabel.translatesAutoresizingMaskIntoConstraints = false
        displayLabel.textColor = .white
        displayLabel.textAlignment = .right
        displayLabel.font = UIFont.systemFont(ofSize: 70, weight: .regular)
        displayLabel.text = "0"
        displayLabel.adjustsFontSizeToFitWidth = true
        displayLabel.minimumScaleFactor = 0.5
        view.addSubview(displayLabel)
        
        // 约束
        NSLayoutConstraint.activate([
            historyLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            historyLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            historyLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            displayLabel.topAnchor.constraint(equalTo: historyLabel.bottomAnchor, constant: 10),
            displayLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            displayLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            displayLabel.heightAnchor.constraint(equalToConstant: 80)
        ])
    }
    
    private func setupButtonGrid() {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: displayLabel.bottomAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10)
        ])
        
        // 科学计算器按钮行
        let scientificRows = [
            ["(", ")", "mc", "m+", "m-", "mr"],
            ["2ⁿᵈ", "x²", "x³", "xʸ", "eˣ", "10ˣ"],
            ["¹⁄ₓ", "²√x", "³√x", "ʸ√x", "ln", "log₁₀"],
            ["x!", "sin", "cos", "tan", "e", "EE"],
            ["Rand", "sinh", "cosh", "tanh", "π", "Deg"]
        ]
        
        // 基本计算器按钮行
        let basicRows = [
            ["AC", "+/-", "%", "÷"],
            ["7", "8", "9", "×"],
            ["4", "5", "6", "-"],
            ["1", "2", "3", "+"],
            ["⌨", "0", ".", "="]
        ]
        
        // 添加科学计算器按钮
        for row in scientificRows {
            let rowStack = createButtonRow(buttons: row, isScientific: true)
            stackView.addArrangedSubview(rowStack)
        }
        
        // 添加基本计算器按钮
        for row in basicRows {
            let rowStack = createButtonRow(buttons: row, isScientific: false)
            stackView.addArrangedSubview(rowStack)
        }
    }
    
    private func createButtonRow(buttons: [String], isScientific: Bool) -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        
        for buttonTitle in buttons {
            let button = UIButton(type: .system)
            button.setTitle(buttonTitle, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: isScientific ? 20 : 24)
            button.setTitleColor(.white, for: .normal)
            button.backgroundColor = getButtonColor(for: buttonTitle, isScientific: isScientific)
            button.layer.cornerRadius = 20
            button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
            stackView.addArrangedSubview(button)
        }
        
        return stackView
    }
    
    private func getButtonColor(for title: String, isScientific: Bool) -> UIColor {
        if isScientific {
            return UIColor(white: 0.2, alpha: 1.0)
        } else {
            switch title {
            case "÷", "×", "-", "+", "=":
                return .systemOrange
            case "AC", "+/-", "%":
                return UIColor(white: 0.3, alpha: 1.0)
            default:
                return UIColor(white: 0.2, alpha: 1.0)
            }
        }
    }
    
    // MARK: - 按钮操作
    @objc private func buttonTapped(_ sender: UIButton) {
        guard let buttonTitle = sender.title(for: .normal) else { return }
        
        switch buttonTitle {
        case "0", "1", "2", "3", "4", "5", "6", "7", "8", "9":
            inputNumber(buttonTitle)
        case ".":
            inputDecimal()
        case "+", "-", "×", "÷":
            performOperation(buttonTitle)
        case "=":
            calculateResult()
        case "AC":
            clearAll()
        case "+/-":
            negateNumber()
        case "%":
            calculatePercentage()
        case "sin":
            performTrigFunction(.sin)
        case "cos":
            performTrigFunction(.cos)
        case "tan":
            performTrigFunction(.tan)
        case "sinh":
            performTrigFunction(.sinh)
        case "cosh":
            performTrigFunction(.cosh)
        case "tanh":
            performTrigFunction(.tanh)
        case "ln":
            performLogarithm(.natural)
        case "log₁₀":
            performLogarithm(.base10)
        case "x²":
            performPower(2)
        case "x³":
            performPower(3)
        case "xʸ":
            performOperation("^")
        case "eˣ":
            performExponential(.e)
        case "10ˣ":
            performExponential(.ten)
        case "²√x":
            performRoot(2)
        case "³√x":
            performRoot(3)
        case "ʸ√x":
            performOperation("√")
        case "¹⁄ₓ":
            performInverse()
        case "π":
            inputPi()
        case "e":
            inputE()
        case "x!":
            calculateFactorial()
        case "EE":
            inputScientificNotation()
        case "Rand":
            generateRandomNumber()
        case "(":
            // 括号功能可以在后续实现
            break
        case ")":
            // 括号功能可以在后续实现
            break
        case "mc":
            memoryClear()
        case "m+":
            memoryAdd()
        case "m-":
            memorySubtract()
        case "mr":
            memoryRecall()
        default:
            break
        }
        
        updateDisplay()
    }
    
    // MARK: - 输入处理
    private func inputNumber(_ number: String) {
        if shouldResetInput {
            currentInput = number
            shouldResetInput = false
        } else {
            if currentInput == "0" {
                currentInput = number
            } else {
                currentInput += number
            }
        }
    }
    
    private func inputDecimal() {
        if shouldResetInput {
            currentInput = "0."
            shouldResetInput = false
        } else if !currentInput.contains(".") {
            currentInput += "."
        }
    }
    
    private func negateNumber() {
        if let value = Double(currentInput), value != 0 {
            currentInput = formatNumber(-value)
        }
    }
    
    private func calculatePercentage() {
        if let value = Double(currentInput) {
            currentInput = formatNumber(value / 100)
        }
    }
    
    private func inputPi() {
        currentInput = formatNumber(Double.pi)
        shouldResetInput = true
    }
    
    private func inputE() {
        currentInput = formatNumber(M_E)
        shouldResetInput = true
    }
    
    private func inputScientificNotation() {
        if !currentInput.contains("e") && currentInput != "0" {
            currentInput += "e"
        }
    }
    
    private func generateRandomNumber() {
        currentInput = formatNumber(Double.random(in: 0...1))
        shouldResetInput = true
    }
    
    // MARK: - 内存操作
    private func memoryClear() {
        memory = 0
    }
    
    private func memoryAdd() {
        if let value = Double(currentInput) {
            memory += value
        }
    }
    
    private func memorySubtract() {
        if let value = Double(currentInput) {
            memory -= value
        }
    }
    
    private func memoryRecall() {
        currentInput = formatNumber(memory)
        shouldResetInput = true
    }
    
    // MARK: - 数学操作
    private func performOperation(_ operation: String) {
        if let value = Double(currentInput) {
            if firstOperand == nil {
                firstOperand = value
                switch operation {
                case "+":
                    currentOperation = .addition
                case "-":
                    currentOperation = .subtraction
                case "×":
                    currentOperation = .multiplication
                case "÷":
                    currentOperation = .division
                case "^":
                    currentOperation = .power
                case "√":
                    currentOperation = .root
                default:
                    break
                }
                historyLabel.text = "\(formatNumber(value))\(getOperationSymbol(operation))"
            } else {
                calculateResult()
                firstOperand = Double(currentInput)
                switch operation {
                case "+":
                    currentOperation = .addition
                case "-":
                    currentOperation = .subtraction
                case "×":
                    currentOperation = .multiplication
                case "÷":
                    currentOperation = .division
                case "^":
                    currentOperation = .power
                case "√":
                    currentOperation = .root
                default:
                    break
                }
                historyLabel.text = "\(formatNumber(firstOperand!))\(getOperationSymbol(operation))"
            }
            shouldResetInput = true
        }
    }
    
    private func getOperationSymbol(_ operation: String) -> String {
        switch operation {
        case "+":
            return "+"
        case "-":
            return "-"
        case "×":
            return "×"
        case "÷":
            return "÷"
        case "^":
            return "^"
        case "√":
            return "√"
        default:
            return ""
        }
    }
    
    private func calculateResult() {
        if let operation = currentOperation, let first = firstOperand, let second = Double(currentInput) {
            var result: Double = 0
            
            switch operation {
            case .addition:
                result = first + second
            case .subtraction:
                result = first - second
            case .multiplication:
                result = first * second
            case .division:
                result = first / second
            case .power:
                result = pow(first, second)
            case .root:
                result = pow(first, 1/second)
            }
            
            historyLabel.text = "\(formatNumber(first))\(getOperationSymbol(operation.rawValue))\(formatNumber(second))"
            currentInput = formatNumber(result)
            firstOperand = nil
            currentOperation = nil
            shouldResetInput = true
        }
    }
    
    private func performTrigFunction(_ function: TrigFunction) {
        if let value = Double(currentInput) {
            var result: Double = 0
            
            switch function {
            case .sin:
                result = sin(value)
            case .cos:
                result = cos(value)
            case .tan:
                result = tan(value)
            case .sinh:
                result = sinh(value)
            case .cosh:
                result = cosh(value)
            case .tanh:
                result = tanh(value)
            }
            
            historyLabel.text = "\(function.rawValue)(\(formatNumber(value)))"
            currentInput = formatNumber(result)
            shouldResetInput = true
        }
    }
    
    private func performLogarithm(_ type: LogarithmType) {
        if let value = Double(currentInput), value > 0 {
            var result: Double = 0
            
            switch type {
            case .natural:
                result = log(value)
                historyLabel.text = "ln(\(formatNumber(value)))"
            case .base10:
                result = log10(value)
                historyLabel.text = "log₁₀(\(formatNumber(value)))"
            }
            
            currentInput = formatNumber(result)
            shouldResetInput = true
        }
    }
    
    private func performPower(_ power: Int) {
        if let value = Double(currentInput) {
            let result = pow(value, Double(power))
            historyLabel.text = "\(formatNumber(value))^\(power)"
            currentInput = formatNumber(result)
            shouldResetInput = true
        }
    }
    
    private func performExponential(_ base: ExponentialBase) {
        if let value = Double(currentInput) {
            var result: Double = 0
            
            switch base {
            case .e:
                result = exp(value)
                historyLabel.text = "e^\(formatNumber(value))"
            case .ten:
                result = pow(10, value)
                historyLabel.text = "10^\(formatNumber(value))"
            }
            
            currentInput = formatNumber(result)
            shouldResetInput = true
        }
    }
    
    private func performRoot(_ root: Int) {
        if let value = Double(currentInput) {
            let result = pow(value, 1.0/Double(root))
            historyLabel.text = "\(root)√\(formatNumber(value))"
            currentInput = formatNumber(result)
            shouldResetInput = true
        }
    }
    
    private func performInverse() {
        if let value = Double(currentInput), value != 0 {
            let result = 1.0 / value
            historyLabel.text = "1/\(formatNumber(value))"
            currentInput = formatNumber(result)
            shouldResetInput = true
        }
    }
    
    private func calculateFactorial() {
        if let value = Double(currentInput), value.truncatingRemainder(dividingBy: 1) == 0, value >= 0, value <= 20 {
            let n = Int(value)
            var result: Double = 1
            
            for i in 1...n {
                result *= Double(i)
            }
            
            historyLabel.text = "\(n)!"
            currentInput = formatNumber(result)
            shouldResetInput = true
        }
    }
    
    // MARK: - 辅助方法
    private func clearAll() {
        currentInput = "0"
        firstOperand = nil
        currentOperation = nil
        historyLabel.text = ""
        shouldResetInput = false
    }
    
    private func updateDisplay() {
        displayLabel.text = currentInput
    }
    
    private func formatNumber(_ number: Double) -> String {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 10
        
        if let formattedNumber = formatter.string(from: NSNumber(value: number)) {
            return formattedNumber
        } else {
            return String(number)
        }
    }
}

// MARK: - 枚举
extension CalculatorViewController {
    enum Operation: String {
        case addition = "+"
        case subtraction = "-"
        case multiplication = "×"
        case division = "÷"
        case power = "^"
        case root = "√"
    }
    
    enum TrigFunction: String {
        case sin = "sin"
        case cos = "cos"
        case tan = "tan"
        case sinh = "sinh"
        case cosh = "cosh"
        case tanh = "tanh"
    }
    
    enum LogarithmType {
        case natural
        case base10
    }
    
    enum ExponentialBase {
        case e
        case ten
    }
}

// MARK: - 应用入口
class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = CalculatorViewController()
        window?.makeKeyAndVisible()
    }
}

//@main
//class AppDelegate: UIResponder, UIApplicationDelegate {
//    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//        return true
//    }
//    
//    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectingSceneOptions) -> UISceneConfiguration {
//        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
//    }
//}
