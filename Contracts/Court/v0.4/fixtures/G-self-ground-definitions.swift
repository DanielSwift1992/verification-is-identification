protocol Base {}
protocol Recursive: Base where Self: Recursive {}
