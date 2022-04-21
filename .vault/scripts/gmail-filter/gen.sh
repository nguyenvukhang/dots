#!/bin/zsh

# usage:
# Go to Gmail > Settings > See all settings > Filters and Blocked Addresses
# Import filters

function delete() {
cat <<EOF
  <entry>
    <category term='filter'></category>
    <title>Mail Filter</title>
EOF
printf "    <apps:property name='hasTheWord' value='{"
for i in $delete_list; do
  printf "from:$i "
done
cat <<EOF
}'/>
    <apps:property name='shouldTrash' value='true'/>
  </entry>
EOF
}

function archive() {
cat <<EOF
  <entry>
    <category term='filter'></category>
    <title>Mail Filter</title>
EOF
printf "    <apps:property name='hasTheWord' value='{"
for i in $archive_list; do
  printf "from:$i "
done
cat <<EOF
}'/>
    <apps:property name='shouldArchive' value='true'/>
    <apps:property name='shouldNeverSpam' value='true'/>
  </entry>
EOF
}

function label() {
for k v in ${(kv)label_list}; do
cat <<EOF
  <entry>
    <category term='filter'></category>
    <title>Mail Filter</title>
    <apps:property name='from' value='${k}'/>"
    <apps:property name='label' value='${v}'/>
    <apps:property name='shouldArchive' value='true'/>
    <apps:property name='shouldNeverSpam' value='true'/>
  </entry>
EOF
done
}

function main() {
  echo "<?xml version='1.0' encoding='UTF-8'?>"
  echo "<feed xmlns='http://www.w3.org/2005/Atom' xmlns:apps='http://schemas.google.com/apps/2006'>"
  echo "  <title>Mail Filters</title>"
  archive
  delete
  label
  echo "</feed>"
}

archive_list=(
\*@e.change.org
\*@singaporetuitionteachers.com
)

delete_list=(
\*@facebookmail.com
\*@facebook.com
\*@instagram.com
)

typeset -A label_list=(
[vercel\[bot\]]='bots/vercel'
)

main

# boostnote.io
# vercel[bot]
# instagram.com
# quora.com
# trainingpeaks.com
# asuswebstorage.com
# suunto.com
# wahoo.com
# positivegrid.com
# goodreads.com
# shopback.sg
# caudabe.com
# aliexpress.com
# codeforces.com
# heroku.com
# grab.com
# wd2go.com
# neweracycle.com
# blinkist.com
# sweelee.com.sg
# artstation.com
# yousician.com
# chainreactioncycles.com
# spitfireaudio.com
# ebay.com
# alpaca.markets
# postman.com
# microsoftstoreemail.com
# progress.com
# dynalist.io
# sp-connect.com
# daisydiskapp.com
# guitar-pro.com
# pinkapple.com
# franklin-christoph.com
# worldwidecyclery.com
# status.co
# quadlockcase.com
# asana.com
# wiggle.com
# gingkowriter.com
# codeanywhere.net
# koithe.com.sg
# sporcle.com
# youtube.com
# standardnotes.com
# gotinder.com
# hexlox.com
# plus500.com
# bandcamp.com
# ninjavan.co
# lazada.sg
# nlb.gov.sg
# togoparts.com
# vercel.com
# dominos.com
# berklee.edu
# giving.sg
# progress.net
# casetify.com
# avid.com
# clevertraining.com
# pcgamingrace.com
# knox.edu
# miamioh.edu
# simons-rock.edu
# autodeskcommunications.com
# avid.com
# baydin.com
# clevertraining.com
# lookcycle.com
# corima.com
# nvpc.org.sg
# nlb.gov.sg
# vudu.com
# getpostman.com
# pcgamingrace.com
# bandlab.com
# casetify.com
# giving.sg
# reverb.com
# sygic.com
# jrc-components.com
# runtastic.com
# competitivecyclist.com
# send.grammarly.com
# ship.vercel.com
# sundownmarathon.com
# merlincycles.com
# dominos.com
# ezbuy.com
# rwgps.com
# togoparts.com
# avid.com
# announcements.hudl.com
# e-pol.it
# salesforce.com
# softube.com
# progress.net
# togoparts.com
# overjoyed.com.sg
# stereo.com.sg
# pdffiller.com
# vercel.com
# penchalet.com
# em.zalora.sg
# bulletjournal.com
# docx2latex.com
# roka.com
# readdlenews.com
# tracktion.com
# e-pol.it
# zalora.sg
# saxomarkets.com
# abasiguitars
# razer.com
# facebookmail.com
# strava.com
# tumblr.com
# tidal.com
# seedly.sg
# shopeemobile.com
# shopee.sg
# amazon.sg
# amazon.com
# tradingwithrayner.com
# behance.com
# twitter.com
# pinterest.com
# reddit.com
# claytrader.com
# wikispaces.com
# ea.com
# wordpress.com
# workflowy.com
# microsoft.com
# 2xurun.com
# invisionapp.com
# hult.edu
# budgetbakers.com
# thestatusaudio.com
# lecol.cc
# codepen.io
# sigmasports.com
# drop.com
# carousell.com
# dropbox.com
# gopro.com
# relive.cc
# marsello.com
# richdad.com
