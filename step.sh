#!/bin/bash
set -ex

# echo "This is the value specified for the input 'example_step_input': ${example_step_input}"

#
# --- Export Environment Variables for other Steps:
# You can export Environment Variables for other Steps with
#  envman, which is automatically installed by `bitrise setup`.
# A very simple example:
# envman add --key EXAMPLE_STEP_OUTPUT --value 'the value you want to share'
# Envman can handle piped inputs, which is useful if the text you want to
# share is complex and you don't want to deal with proper bash escaping:
#  cat file_with_complex_input | envman add --KEY EXAMPLE_STEP_OUTPUT
# You can find more usage examples on envman's GitHub page
#  at: https://github.com/bitrise-io/envman

#
# --- Exit codes:
# The exit code of your Step is very important. If you return
#  with a 0 exit code `bitrise` will register your Step as "successful".
# Any non zero exit code will be registered as "failed" by `bitrise`.


# Telegram Bot API URL
api_url="https://api.telegram.org/bot${telegram_bot_token}/sendMessage"

# Chat ID of the recipient
chat_id="${telegram_chat_id}"


MESSAGE="🛑 *$BITRISE_APP_TITLE*: build $BITRISE_BUILD_NUMBER failed 😕 \\nURL: $BITRISE_APP_URL\\nCommit: $BITRISE_GIT_MESSAGE \\n\\n $custom_message"

if [ $BITRISE_BUILD_STATUS -eq 0 ] ; then MESSAGE="✅ <b>$BITRISE_APP_TITLE</b>: build $BITRISE_BUILD_NUMBER passed! 🎉\\nCommit: <code>$BITRISE_GIT_MESSAGE</code> \\nDownload URL ⬇️: $download_url \\n\\n$custom_message" ; fi

payload="{ \"chat_id\": \"'${telegram_chat_id}'\", \"text\":\"$MESSAGE\", \"parse_mode\": \"HTML\" }"

# Message text with Markdown formatting and escaped characters
# message="This is an example *bold* message with _italic_ and \`code\`.
# You can also include newlines in the message by using \\n."

# Escape characters for Markdown formatting and newlines
escaped_message=$(echo "$MESSAGE" | sed 's/\*/\\*/g; s/_/\\_/g; s/`/\\`/g; s/\\n/\\n/g')

# Check if the environment variable is set to true
if [[ ${link_previews_enabled} == "yes" ]]; then
  disable_preview="true"
else
  disable_preview="false"
fi



# RESULT=$(curl -X POST https://api.telegram.org/bot${telegram_bot_token}/sendMessage \
# -H "Content-Type: application/json" \
# -d @- <<EOF
# {
#     "chat_id":"${telegram_chat_id}", 
#     "text":"$MESSAGE",
#     "parse_mode":"HTML"
# }
# EOF)

RESULT=$(curl -s -X POST "$api_url" \
  -d "chat_id=$chat_id" \
  -d "text=$escaped_message" \
  -d "parse_mode=Markdown" \
  -d "disable_web_page_preview=$disable_preview")

# echo "$payload"
# echo "$BITRISE_GIT_MESSAGE"
# echo "$MESSAGE"
echo "$RESULT"

