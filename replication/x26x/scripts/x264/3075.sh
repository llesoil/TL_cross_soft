#!/bin/sh

numb='3076'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --slow-firstpass --weightb --aq-strength 1.5 --ipratio 1.2 --pbratio 1.4 --psy-rd 1.8 --qblur 0.4 --qcomp 0.7 --vbv-init 0.2 --aq-mode 0 --b-adapt 1 --bframes 12 --crf 5 --keyint 210 --lookahead-threads 1 --min-keyint 29 --qp 30 --qpstep 4 --qpmin 1 --qpmax 69 --rc-lookahead 38 --ref 5 --vbv-bufsize 1000 --deblock -1:-1 --me dia --overscan crop --preset veryslow --scenecut 0 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,--slow-firstpass,--weightb,1.5,1.2,1.4,1.8,0.4,0.7,0.2,0,1,12,5,210,1,29,30,4,1,69,38,5,1000,-1:-1,dia,crop,veryslow,0,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"