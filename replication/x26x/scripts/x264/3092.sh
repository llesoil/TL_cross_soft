#!/bin/sh

numb='3093'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --no-weightb --aq-strength 0.5 --ipratio 1.5 --pbratio 1.4 --psy-rd 2.8 --qblur 0.6 --qcomp 0.7 --vbv-init 0.6 --aq-mode 1 --b-adapt 1 --bframes 6 --crf 20 --keyint 230 --lookahead-threads 0 --min-keyint 30 --qp 30 --qpstep 5 --qpmin 1 --qpmax 68 --rc-lookahead 18 --ref 1 --vbv-bufsize 2000 --deblock 1:1 --me hex --overscan show --preset slow --scenecut 30 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,None,--no-weightb,0.5,1.5,1.4,2.8,0.6,0.7,0.6,1,1,6,20,230,0,30,30,5,1,68,18,1,2000,1:1,hex,show,slow,30,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"