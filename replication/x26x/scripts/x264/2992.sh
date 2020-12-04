#!/bin/sh

numb='2993'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --no-weightb --aq-strength 0.0 --ipratio 1.4 --pbratio 1.2 --psy-rd 0.8 --qblur 0.6 --qcomp 0.6 --vbv-init 0.4 --aq-mode 1 --b-adapt 0 --bframes 2 --crf 35 --keyint 200 --lookahead-threads 3 --min-keyint 28 --qp 40 --qpstep 5 --qpmin 0 --qpmax 63 --rc-lookahead 38 --ref 2 --vbv-bufsize 2000 --deblock 1:1 --me hex --overscan show --preset placebo --scenecut 30 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,None,--no-weightb,0.0,1.4,1.2,0.8,0.6,0.6,0.4,1,0,2,35,200,3,28,40,5,0,63,38,2,2000,1:1,hex,show,placebo,30,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"