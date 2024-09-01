#!/bin/bash

if [ "$(uname)" = 'Darwin' ]; then
    # Mac
    # あとで作るかも
    :
elif [ "$(uname)" = 'Linux' ]; then
    # Linux

    # $ vmstat
    # procs -------------memory----------- ---swap-- -----io---- -system-- -------cpu-------
    # r  b    swpd    free   buff    cache   si   so    bi    bo   in   cs us sy  id wa st gu
    # 1  0  493240 1882736  66020 62263012    0    0   328   629  260    0  0  0 100  0  0  0
    cpu_result="$(vmstat | tail -n 1 | tr -s ' ' | cut -d ' ' -f 14-)" # user, system, idle, wait, steal, guest
    cpu_user="$(echo "${cpu_result}" | cut -d ' ' -f 1)"
    cpu_system="$(echo "${cpu_result}" | cut -d ' ' -f 2)"
    # cpu_idle="$(echo "${cpu_result}" | cut -d ' ' -f 3)"
    cpu_wait="$(echo "${cpu_result}" | cut -d ' ' -f 4)"
    cpu_steal="$(echo "${cpu_result}" | cut -d ' ' -f 5)"
    # cpu_guest="$(echo "${cpu_result}" | cut -d ' ' -f 6)"

    # $ vmstat -s | awk '/ K / {sub(/K/, ""); printf "%.2f GB %s %s\n", $1/1024/1024, $2, $3}'
    # 62.48 GB total memory
    # 1.96 GB used memory
    # 31.59 GB active memory
    # 25.65 GB inactive memory
    # 1.80 GB free memory
    # 0.06 GB buffer memory
    # 59.38 GB swap cache
    # 8.00 GB total swap
    # 0.47 GB used swap
    # 7.53 GB free swap
    # 328.56 GB paged in
    # 629.40 GB paged out
    memory_result="$(vmstat -s | awk '/ K / {sub(/K/, ""); printf "%.2fG %s %s\n", $1/1024/1024, $2, $3}')"
    # memory_total="$(echo      "${memory_result}" | head -n 1  | tail -n 1 | cut -d ' ' -f1)"
    memory_used="$(echo       "${memory_result}" | head -n 2  | tail -n 1 | cut -d ' ' -f1)"
    memory_active="$(echo     "${memory_result}" | head -n 3  | tail -n 1 | cut -d ' ' -f1)"
    memory_inactive="$(echo   "${memory_result}" | head -n 4  | tail -n 1 | cut -d ' ' -f1)"
    memory_free="$(echo       "${memory_result}" | head -n 5  | tail -n 1 | cut -d ' ' -f1)"
    # memory_buffer="$(echo     "${memory_result}" | head -n 6  | tail -n 1 | cut -d ' ' -f1)"
    # memory_swap_cache="$(echo "${memory_result}" | head -n 7  | tail -n 1 | cut -d ' ' -f1)"
    # memory_total_swap="$(echo "${memory_result}" | head -n 8  | tail -n 1 | cut -d ' ' -f1)"
    memory_used_swap="$(echo  "${memory_result}" | head -n 9  | tail -n 1 | cut -d ' ' -f1)"
    memory_free_swap="$(echo  "${memory_result}" | head -n 10 | tail -n 1 | cut -d ' ' -f1)"
    memory_paged_in="$(echo   "${memory_result}" | head -n 11 | tail -n 1 | cut -d ' ' -f1)"
    memory_paged_out="$(echo  "${memory_result}" | head -n 12 | tail -n 1 | cut -d ' ' -f1)"

    echo -n "[CPU]user:${cpu_user},sys:${cpu_system},wait:${cpu_wait},steal:${cpu_steal}"
    echo -n "|"
    echo -n "[MEM]used:${memory_used},active:${memory_active},inactive:${memory_inactive},free:${memory_free}"
    echo -n "|"
    echo -n "[SWAP]used:${memory_used_swap},free:${memory_free_swap}"
    echo -n "|"
    echo -n "[PAGE]in:${memory_paged_in},out:${memory_paged_out}"
fi
