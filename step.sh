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

MESSAGE="🛑 *$BITRISE_APP_TITLE*: build $BITRISE_BUILD_NUMBER failed 😕 \nURL: $BITRISE_APP_URL\nCommit: $BITRISE_GIT_MESSAGE \n\n $custom_message"

if [ $BITRISE_BUILD_STATUS -eq 0 ] ; then MESSAGE="✅ *$BITRISE_APP_TITLE*: build $BITRISE_BUILD_NUMBER passed! 🎉\nCommit: $BITRISE_GIT_MESSAGE\n Download URL ⬇️: $download_url\n\n $custom_message" ; fi

curl -X POST -H "Content-Type: application/json" -d "{ \"chat_id\": \"$telegram_chat_id\", \"text\":\"$MESSAGE\", \"parse_mode\": \"markdown\", \"disable_web_page_preview\": \"true\" }" https://api.telegram.org/bot$telegram_bot_token/sendMessage

