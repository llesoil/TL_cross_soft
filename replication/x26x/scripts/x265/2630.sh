#!/bin/sh

numb='2631'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --no-weightb --aq-strength 1.0 --ipratio 1.5 --pbratio 1.0 --psy-rd 4.2 --qblur 0.3 --qcomp 0.7 --vbv-init 0.5 --aq-mode 0 --b-adapt 0 --bframes 8 --crf 35 --keyint 220 --lookahead-threads 4 --min-keyint 22 --qp 20 --qpstep 5 --qpmin 2 --qpmax 69 --rc-lookahead 38 --ref 1 --vbv-bufsize 1000 --deblock -1:-1 --me umh --overscan show --preset veryslow --scenecut 10 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,None,--no-weightb,1.0,1.5,1.0,4.2,0.3,0.7,0.5,0,0,8,35,220,4,22,20,5,2,69,38,1,1000,-1:-1,umh,show,veryslow,10,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"