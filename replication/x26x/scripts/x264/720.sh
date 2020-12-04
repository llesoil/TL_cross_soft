#!/bin/sh

numb='721'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --weightb --aq-strength 0.0 --ipratio 1.4 --pbratio 1.1 --psy-rd 1.4 --qblur 0.5 --qcomp 0.7 --vbv-init 0.6 --aq-mode 0 --b-adapt 2 --bframes 16 --crf 30 --keyint 270 --lookahead-threads 2 --min-keyint 20 --qp 40 --qpstep 5 --qpmin 2 --qpmax 60 --rc-lookahead 18 --ref 2 --vbv-bufsize 2000 --deblock -2:-2 --me dia --overscan show --preset faster --scenecut 0 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,None,--weightb,0.0,1.4,1.1,1.4,0.5,0.7,0.6,0,2,16,30,270,2,20,40,5,2,60,18,2,2000,-2:-2,dia,show,faster,0,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"