#!/usr/bin/env bash

# Initialize PHP7

# PHP Config

# Get all environment variables in a map
if [ -f "/etc/alpine-release" ] ; then
    # This is an alpine so env and printenv are different: Cannot handle multi-line variable
    str_env_variables=$(env | while IFS='=' read -r n v; do
        printf "['%s']='%s' " "$n" "$v"
    done);
else
    # Can handle multiline variables
    str_env_variables=$(env -0 | while IFS='=' read -r -d '' n v; do
        printf "['%s']='%s' " "$n" "$v"
    done);
fi

declare -A env_vars="($str_env_variables)"

# Show all environment
#for env_key in "${!env_vars[@]}"; do
#    echo "$env_key=${env_vars[$env_key]}";
#done


declare -A env_2_config_var
env_2_config_var=(
    ["PHP_SHORT_OPEN_TAG"]="short_open_tag"
    ["PHP_OUTPUT_BUFFERING"]="output_buffering"
    ["PHP_OPEN_BASEDIR"]="open_basedir"
    ["PHP_MAX_EXECUTION_TIME"]="max_execution_time"
    ["PHP_MAX_INPUT_TIME"]="max_input_time"
    ["PHP_MAX_INPUT_VARS"]="max_input_vars"
    ["PHP_MEMORY_LIMIT"]="memory_limit"
    ["PHP_ERROR_REPORTING"]="error_reporting"
    ["PHP_DISPLAY_ERRORS"]="display_errors"
    ["PHP_DISPLAY_STARTUP_ERRORS"]="display_startup_errors"
    ["PHP_LOG_ERRORS"]="log_errors"
    ["PHP_LOG_ERRORS_MAX_LEN"]="log_errors_max_len"
    ["PHP_IGNORE_REPEATED_ERRORS"]="ignore_repeated_errors"
    ["PHP_REPORT_MEMLEAKS"]="report_memleaks"
    ["PHP_HTML_ERRORS"]="html_errors"
    ["PHP_ERROR_LOG"]="error_log"
    ["PHP_POST_MAX_SIZE"]="post_max_size"
    ["PHP_DEFAULT_MIMETYPE"]="default_mimetype"
    ["PHP_DEFAULT_CHARSET"]="default_charset"
    ["PHP_FILE_UPLOADS"]="file_uploads"
    ["PHP_UPLOAD_TMP_DIR"]="upload_tmp_dir"
    ["PHP_UPLOAD_MAX_FILESIZE"]="upload_max_filesize"
    ["PHP_MAX_FILE_UPLOADS"]="max_file_uploads"
    ["PHP_ALLOW_URL_FOPEN"]="allow_url_fopen"
    ["PHP_ALLOW_URL_INCLUDE"]="allow_url_include"
    ["PHP_DEFAULT_SOCKET_TIMEOUT"]="default_socket_timeout"
    ["PHP_DATE_TIMEZONE"]="date.timezone"
    ["PHP_PDO_MYSQL_CACHE_SIZE"]="pdo_mysql.cache_size"
    ["PHP_PDO_MYSQL_DEFAULT_SOCKET"]="pdo_mysql.default_socket"
    ["PHP_SESSION_SAVE_HANDLER"]="session.save_handler"
    ["PHP_SESSION_SAVE_PATH"]="session.save_path"
    ["PHP_SESSION_USE_STRICT_MODE"]="session.use_strict_mode"
    ["PHP_SESSION_USE_COOKIES"]="session.use_cookies"
    ["PHP_SESSION_COOKIE_SECURE"]="session.cookie_secure"
    ["PHP_SESSION_NAME"]="session.name"
    ["PHP_SESSION_COOKIE_LIFETIME"]="session.cookie_lifetime"
    ["PHP_SESSION_COOKIE_PATH"]="session.cookie_path"
    ["PHP_SESSION_COOKIE_DOMAIN"]="session.cookie_domain"
    ["PHP_SESSION_COOKIE_HTTPONLY"]="session.cookie_httponly"
)

php_env_matcher="^PHP_"
for env_key in "${!env_vars[@]}"; do
    if [[ $env_key =~ $php_env_matcher ]]; then
        if [ ! -z "${env_vars[$env_key]}" ]; then
            if [ ! -z "${env_2_config_var[$env_key]}" ] ; then
                echo "Set PHP ${env_2_config_var[$env_key]} = ${env_vars[$env_key]}"
                sed -i "s/\;\?\\s\?${env_2_config_var[$env_key]} = .*/${env_2_config_var[$env_key]} = ${env_vars[$env_key]}/" /etc/php7/php.ini
            fi
        fi;
    fi
done
