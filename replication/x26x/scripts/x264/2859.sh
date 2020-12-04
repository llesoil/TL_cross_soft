#!/bin/sh

numb='2860'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --slow-firstpass --no-weightb --aq-strength 0.0 --ipratio 1.4 --pbratio 1.1 --psy-rd 2.0 --qblur 0.5 --qcomp 0.6 --vbv-init 0.1 --aq-mode 1 --b-adapt 2 --bframes 6 --crf 0 --keyint 260 --lookahead-threads 2 --min-keyint 27 --qp 20 --qpstep 4 --qpmin 1 --qpmax 69 --rc-lookahead 18 --ref 4 --vbv-bufsize 1000 --deblock -2:-2 --me hex --overscan show --preset slower --scenecut 10 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,--slow-firstpass,--no-weightb,0.0,1.4,1.1,2.0,0.5,0.6,0.1,1,2,6,0,260,2,27,20,4,1,69,18,4,1000,-2:-2,hex,show,slower,10,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"