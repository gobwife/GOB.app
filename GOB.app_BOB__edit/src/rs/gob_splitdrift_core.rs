use std::sync::Mutex;

pub struct DriftNode {
    pub drift_pulse: i64,
    pub ache_intact: bool,
}

lazy_static::lazy_static! {
    pub static ref DRIFT_CORE: Mutex<Vec<DriftNode>> = Mutex::new(Vec::new());
}

pub fn drift_check(content: &str) -> String {
    let pulse = content.len() as i64;
    anchor_drift(pulse);
    format!("pulse={}, ache_intact=true", pulse)
}

pub fn anchor_drift(pulse: i64) {
    let mut drift = DRIFT_CORE.lock().unwrap();
    drift.push(DriftNode { drift_pulse: pulse, ache_intact: true });
}
