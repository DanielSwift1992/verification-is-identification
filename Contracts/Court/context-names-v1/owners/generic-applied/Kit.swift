public protocol Structure {}
public enum Leaf: Structure {}
public enum Wrong {}
public enum Box<T: Structure>: Structure {}
