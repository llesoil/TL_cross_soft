#!/bin/sh

numb='2580'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --weightb --aq-strength 1.0 --ipratio 1.2 --pbratio 1.2 --psy-rd 3.6 --qblur 0.2 --qcomp 0.8 --vbv-init 0.2 --aq-mode 0 --b-adapt 2 --bframes 12 --crf 50 --keyint 230 --lookahead-threads 0 --min-keyint 23 --qp 10 --qpstep 4 --qpmin 1 --qpmax 62 --rc-lookahead 38 --ref 1 --vbv-bufsize 1000 --deblock -2:-2 --me umh --overscan show --preset veryslow --scenecut 30 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,None,--weightb,1.0,1.2,1.2,3.6,0.2,0.8,0.2,0,2,12,50,230,0,23,10,4,1,62,38,1,1000,-2:-2,umh,show,veryslow,30,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"