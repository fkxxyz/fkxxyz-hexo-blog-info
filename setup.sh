#!/bin/bash

workdir="$(cd "$(dirname "$0")" && pwd)"

default_blog_templete=~/Documents/hexo-templete.tar.xz
default_hexo_home=~/hexo
default_public_branch=~/github.com/fkxxyz/fkxxyz.github.io

main(){
	# $1 指定要解压的 博客目录模板压缩包 若不指定，则为默认值
	# $2 指定要解压的位置，若不指定，则为默认值
	# $3 指定网站的本地仓库目录，若不指定，则为默认值
	
	local blog_templete="$1"
	local hexo_home="$2"
	local public_branch="$3"
	
	[ "$blog_templete" ] || blog_templete="$default_blog_templete"
	[ "$hexo_home" ] || hexo_home="$default_hexo_home"
	[ "$public_branch" ] || public_branch="$default_public_branch"
	
	# 若目标已存在，则要确保当前存在的是已经链接过的博客目录，再删除
	if [ -d "$hexo_home" ]; then
		if [ ! -h "$hexo_home/source" ]; then
			echo '目标目录无法识别！请确保此目录无用，手动删除后重试。' >&2
			exit 1
		fi
		rm -rf "$hexo_home" || exit 1
	fi
	
	# 将 博客目录模板压缩包 解压到目标目录
	mkdir "$hexo_home" || exit 1
	tar xf ~/Documents/hexo-templete.tar.xz -C "$hexo_home" || exit 1
	mv "$hexo_home/hexo-templete/"* "$hexo_home" || exit 1
	rm -r "$hexo_home/hexo-templete" || exit 1

	# 替换、链接目标目录的一些东西
	ln -sf "$workdir/_config.yml" "$hexo_home/_config.yml" || exit 1
	ln -sf "$workdir/source" "$hexo_home/source" || exit 1
	ln -sf "$public_branch" "$hexo_home/.deploy_git" || exit 1
}

main "$@"

