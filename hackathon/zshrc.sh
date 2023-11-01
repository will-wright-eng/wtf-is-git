gitbot() {
	local prompt="$1"
	local data_path="data/combined-csvs.txt"
	local repo_path="/Users/ww931d/repos/eatingsoftware"
	bash "$repo_path/vgpt/ask.sh" "$prompt" "$repo_path/$data_path" "$repo_path"
}