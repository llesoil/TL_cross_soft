#!/bin/sh

numb='1112'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --slow-firstpass --weightb --aq-strength 1.0 --ipratio 1.0 --pbratio 1.3 --psy-rd 1.2 --qblur 0.4 --qcomp 0.9 --vbv-init 0.0 --aq-mode 0 --b-adapt 0 --bframes 0 --crf 45 --keyint 230 --lookahead-threads 0 --min-keyint 24 --qp 40 --qpstep 4 --qpmin 3 --qpmax 68 --rc-lookahead 48 --ref 2 --vbv-bufsize 1000 --deblock -2:-2 --me dia --overscan show --preset placebo --scenecut 40 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,--slow-firstpass,--weightb,1.0,1.0,1.3,1.2,0.4,0.9,0.0,0,0,0,45,230,0,24,40,4,3,68,48,2,1000,-2:-2,dia,show,placebo,40,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"