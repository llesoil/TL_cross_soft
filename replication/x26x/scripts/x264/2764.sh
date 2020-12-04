#!/bin/sh

numb='2765'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --weightb --aq-strength 0.5 --ipratio 1.5 --pbratio 1.3 --psy-rd 1.4 --qblur 0.3 --qcomp 0.6 --vbv-init 0.8 --aq-mode 1 --b-adapt 2 --bframes 0 --crf 10 --keyint 250 --lookahead-threads 0 --min-keyint 22 --qp 20 --qpstep 5 --qpmin 1 --qpmax 60 --rc-lookahead 48 --ref 6 --vbv-bufsize 2000 --deblock -1:-1 --me hex --overscan crop --preset placebo --scenecut 40 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,None,--weightb,0.5,1.5,1.3,1.4,0.3,0.6,0.8,1,2,0,10,250,0,22,20,5,1,60,48,6,2000,-1:-1,hex,crop,placebo,40,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"