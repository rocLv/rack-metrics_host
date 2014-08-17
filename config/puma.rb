environment 'production'

threads 1,4

bind  "unix:/path/to/app/puma/puma.sock"
pidfile "/path/to/app/puma/pid"
state_path "/path/to/app/puma/state"

activate_control_app
