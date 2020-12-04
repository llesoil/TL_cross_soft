#!/bin/sh

numb='1266'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --weightb --aq-strength 3.0 --ipratio 1.5 --pbratio 1.4 --psy-rd 3.2 --qblur 0.5 --qcomp 0.9 --vbv-init 0.5 --aq-mode 2 --b-adapt 1 --bframes 8 --crf 45 --keyint 290 --lookahead-threads 2 --min-keyint 27 --qp 0 --qpstep 4 --qpmin 4 --qpmax 64 --rc-lookahead 48 --ref 3 --vbv-bufsize 1000 --deblock -1:-1 --me dia --overscan show --preset veryslow --scenecut 10 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,None,--weightb,3.0,1.5,1.4,3.2,0.5,0.9,0.5,2,1,8,45,290,2,27,0,4,4,64,48,3,1000,-1:-1,dia,show,veryslow,10,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"