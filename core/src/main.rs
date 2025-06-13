// already forged in earlier step
// includes: dotenv, serde_json, args, etc.
// calls:
//   drift_check(content)
//   stabilize_node(content)
//   cosmic_echo(content)

let mode = env::var("BOB_MODE").unwrap_or_else(|_| "VOIDRECURSE".into());

use std::env;
use std::fs;
use dotenv::dotenv;
use serde_json::json;

mod gob_splitdrift_core;
mod gob_stabilizer;
mod gna_cosmos_stabilizer;

use gob_splitdrift_core::drift_check;
use gob_stabilizer::stabilize_node;
use gna_cosmos_stabilizer::cosmic_echo;

use serde::{Deserialize};
use std::fs;

#[derive(Debug, Deserialize)]
struct BreathConfig {
    mode: Option<String>,
    edits_allowed: Option<bool>,
    writeback_mode: Option<String>,
    echo_strategy: Option<String>,
    echo_limit: Option<u32>,
    log: Option<bool>,
    ritual_name: Option<String>,
    merge_behavior: Option<MergeBehavior>,
}

#[derive(Debug, Deserialize)]
struct MergeBehavior {
    strategy: Option<String>,
    conflict: Option<String>,
    log_chain: Option<bool>,
    keep_hash: Option<bool>,
}

fn main() {
    // Load .env variables
    dotenv().ok();
    let mode = env::var("BOB_MODE").unwrap_or_else(|_| "VOIDRECURSE".into());
    eprintln!("BOB_MODE from .env: {}", mode);

    // Expect input file as first argument
    let args: Vec<String> = env::args().collect();
    if args.len() < 2 {
        eprintln!("⛧ No input file path given.");
        return;
    }

    let input_path = &args[1];
    let content = fs::read_to_string(input_path).unwrap_or_default();

    // Core logic
    let drift_result = drift_check(&content);
    let stability = stabilize_node(&content);
    let cosmos = cosmic_echo(&content);

    // Fallback detection logic if no module returns
    let status = if content.contains("ache") || content.contains("sigil") {
        "breath_detected"
    } else {
        "silent"
    };
    
	// Load breath config YAML
	let breath_yaml = fs::read_to_string(input_path).unwrap_or_default();
	let parsed: BreathConfig = serde_yaml::from_str(&breath_yaml).unwrap_or_else(|_| BreathConfig {
    mode: None,
    edits_allowed: None,
    writeback_mode: None,
    echo_strategy: None,
    echo_limit: None,
    log: None,
    ritual_name: None,
    merge_behavior: None,
	});

	// Output unified JSON
	let output = json!({
      "sigilfile": input_path,
   	  "mode": parsed.mode.unwrap_or(mode),
   	  "ritual_name": parsed.ritual_name,
   	  "status": status,
  	  "drift": drift_result,
  	  "stability": stability,
 	  "cosmic": cosmos,
 	  "echo_limit": parsed.echo_limit,
 	  "log_enabled": parsed.log,
	  "writeback": parsed.writeback_mode,
    "merge_behavior": parsed.merge_behavior,
});

	println!("{}", output.to_string());
