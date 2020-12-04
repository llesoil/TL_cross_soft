#!/bin/sh

numb='1788'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --slow-firstpass --weightb --aq-strength 0.5 --ipratio 1.1 --pbratio 1.0 --psy-rd 5.0 --qblur 0.2 --qcomp 0.9 --vbv-init 0.1 --aq-mode 0 --b-adapt 0 --bframes 4 --crf 40 --keyint 210 --lookahead-threads 1 --min-keyint 26 --qp 0 --qpstep 4 --qpmin 0 --qpmax 60 --rc-lookahead 18 --ref 1 --vbv-bufsize 2000 --deblock -2:-2 --me hex --overscan crop --preset veryslow --scenecut 40 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,--slow-firstpass,--weightb,0.5,1.1,1.0,5.0,0.2,0.9,0.1,0,0,4,40,210,1,26,0,4,0,60,18,1,2000,-2:-2,hex,crop,veryslow,40,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"