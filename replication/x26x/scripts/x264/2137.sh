#!/bin/sh

numb='2138'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --slow-firstpass --weightb --aq-strength 3.0 --ipratio 1.0 --pbratio 1.4 --psy-rd 5.0 --qblur 0.4 --qcomp 0.7 --vbv-init 0.4 --aq-mode 3 --b-adapt 0 --bframes 10 --crf 20 --keyint 220 --lookahead-threads 1 --min-keyint 21 --qp 10 --qpstep 5 --qpmin 4 --qpmax 67 --rc-lookahead 38 --ref 5 --vbv-bufsize 1000 --deblock -1:-1 --me umh --overscan show --preset veryslow --scenecut 40 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,--slow-firstpass,--weightb,3.0,1.0,1.4,5.0,0.4,0.7,0.4,3,0,10,20,220,1,21,10,5,4,67,38,5,1000,-1:-1,umh,show,veryslow,40,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"