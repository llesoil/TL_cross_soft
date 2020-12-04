#!/bin/sh

numb='693'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --no-weightb --aq-strength 0.0 --ipratio 1.3 --pbratio 1.1 --psy-rd 0.6 --qblur 0.4 --qcomp 0.8 --vbv-init 0.8 --aq-mode 0 --b-adapt 0 --bframes 16 --crf 45 --keyint 210 --lookahead-threads 1 --min-keyint 30 --qp 50 --qpstep 5 --qpmin 2 --qpmax 66 --rc-lookahead 28 --ref 1 --vbv-bufsize 1000 --deblock -2:-2 --me hex --overscan show --preset veryslow --scenecut 0 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,None,--no-weightb,0.0,1.3,1.1,0.6,0.4,0.8,0.8,0,0,16,45,210,1,30,50,5,2,66,28,1,1000,-2:-2,hex,show,veryslow,0,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"