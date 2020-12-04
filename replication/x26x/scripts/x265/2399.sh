#!/bin/sh

numb='2400'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --weightb --aq-strength 3.0 --ipratio 1.3 --pbratio 1.1 --psy-rd 2.6 --qblur 0.5 --qcomp 0.7 --vbv-init 0.0 --aq-mode 3 --b-adapt 1 --bframes 16 --crf 40 --keyint 230 --lookahead-threads 4 --min-keyint 23 --qp 0 --qpstep 5 --qpmin 2 --qpmax 63 --rc-lookahead 38 --ref 2 --vbv-bufsize 1000 --deblock -2:-2 --me hex --overscan show --preset veryslow --scenecut 40 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,None,--weightb,3.0,1.3,1.1,2.6,0.5,0.7,0.0,3,1,16,40,230,4,23,0,5,2,63,38,2,1000,-2:-2,hex,show,veryslow,40,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"