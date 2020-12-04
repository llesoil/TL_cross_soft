#!/bin/sh

numb='916'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --slow-firstpass --weightb --aq-strength 1.0 --ipratio 1.0 --pbratio 1.2 --psy-rd 3.8 --qblur 0.2 --qcomp 0.7 --vbv-init 0.0 --aq-mode 2 --b-adapt 0 --bframes 8 --crf 0 --keyint 210 --lookahead-threads 3 --min-keyint 21 --qp 20 --qpstep 5 --qpmin 4 --qpmax 61 --rc-lookahead 18 --ref 2 --vbv-bufsize 1000 --deblock -1:-1 --me dia --overscan crop --preset veryslow --scenecut 40 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,--slow-firstpass,--weightb,1.0,1.0,1.2,3.8,0.2,0.7,0.0,2,0,8,0,210,3,21,20,5,4,61,18,2,1000,-1:-1,dia,crop,veryslow,40,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"