// Internal failures of the where court are data. Only the CLI boundary writes
// to stderr and exits; a caller can tell unread syntax from unavailable input
// without reading diagnostic text or an exit status.

#[derive(Debug, Clone)]
pub enum Failure {
    Unsupported(Vec<String>),
    Input(Vec<String>),
    Open(Vec<String>),
}

impl Failure {
    pub fn messages(&self) -> &[String] {
        match self {
            Failure::Unsupported(m) | Failure::Input(m) | Failure::Open(m) => m,
        }
    }
}

pub fn fail<T>(message: impl Into<String>) -> Result<T, Failure> {
    Err(Failure::Unsupported(vec![message.into()]))
}

pub fn fail_all<T>(messages: Vec<String>) -> Result<T, Failure> {
    Err(Failure::Unsupported(messages))
}
