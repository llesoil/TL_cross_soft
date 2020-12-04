#!/bin/sh

numb='2989'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --slow-firstpass --weightb --aq-strength 3.0 --ipratio 1.0 --pbratio 1.1 --psy-rd 3.4 --qblur 0.6 --qcomp 0.9 --vbv-init 0.8 --aq-mode 0 --b-adapt 0 --bframes 12 --crf 20 --keyint 280 --lookahead-threads 3 --min-keyint 25 --qp 50 --qpstep 3 --qpmin 2 --qpmax 64 --rc-lookahead 48 --ref 6 --vbv-bufsize 1000 --deblock -2:-2 --me dia --overscan show --preset veryslow --scenecut 30 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,--slow-firstpass,--weightb,3.0,1.0,1.1,3.4,0.6,0.9,0.8,0,0,12,20,280,3,25,50,3,2,64,48,6,1000,-2:-2,dia,show,veryslow,30,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"