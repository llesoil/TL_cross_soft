#!/bin/sh

numb='2561'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --slow-firstpass --no-weightb --aq-strength 2.0 --ipratio 1.3 --pbratio 1.0 --psy-rd 4.4 --qblur 0.3 --qcomp 0.8 --vbv-init 0.9 --aq-mode 3 --b-adapt 2 --bframes 8 --crf 5 --keyint 270 --lookahead-threads 4 --min-keyint 27 --qp 0 --qpstep 3 --qpmin 4 --qpmax 68 --rc-lookahead 18 --ref 4 --vbv-bufsize 1000 --deblock -2:-2 --me hex --overscan crop --preset faster --scenecut 0 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,--slow-firstpass,--no-weightb,2.0,1.3,1.0,4.4,0.3,0.8,0.9,3,2,8,5,270,4,27,0,3,4,68,18,4,1000,-2:-2,hex,crop,faster,0,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"