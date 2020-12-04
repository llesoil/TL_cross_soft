#!/bin/sh

numb='2581'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --no-weightb --aq-strength 2.0 --ipratio 1.5 --pbratio 1.3 --psy-rd 2.6 --qblur 0.6 --qcomp 0.9 --vbv-init 0.5 --aq-mode 1 --b-adapt 2 --bframes 0 --crf 45 --keyint 210 --lookahead-threads 2 --min-keyint 29 --qp 20 --qpstep 3 --qpmin 1 --qpmax 61 --rc-lookahead 18 --ref 2 --vbv-bufsize 1000 --deblock -1:-1 --me umh --overscan show --preset ultrafast --scenecut 10 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,None,--no-weightb,2.0,1.5,1.3,2.6,0.6,0.9,0.5,1,2,0,45,210,2,29,20,3,1,61,18,2,1000,-1:-1,umh,show,ultrafast,10,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"