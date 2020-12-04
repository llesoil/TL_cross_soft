#!/bin/sh

numb='2498'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --slow-firstpass --no-weightb --aq-strength 3.0 --ipratio 1.2 --pbratio 1.0 --psy-rd 4.0 --qblur 0.2 --qcomp 0.6 --vbv-init 0.8 --aq-mode 3 --b-adapt 1 --bframes 14 --crf 20 --keyint 240 --lookahead-threads 0 --min-keyint 25 --qp 50 --qpstep 5 --qpmin 1 --qpmax 60 --rc-lookahead 18 --ref 3 --vbv-bufsize 2000 --deblock -2:-2 --me hex --overscan show --preset veryslow --scenecut 0 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,--slow-firstpass,--no-weightb,3.0,1.2,1.0,4.0,0.2,0.6,0.8,3,1,14,20,240,0,25,50,5,1,60,18,3,2000,-2:-2,hex,show,veryslow,0,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"