#!/bin/sh

numb='2741'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --weightb --aq-strength 2.5 --ipratio 1.1 --pbratio 1.3 --psy-rd 0.2 --qblur 0.2 --qcomp 0.9 --vbv-init 0.1 --aq-mode 1 --b-adapt 0 --bframes 16 --crf 5 --keyint 270 --lookahead-threads 3 --min-keyint 25 --qp 20 --qpstep 3 --qpmin 1 --qpmax 63 --rc-lookahead 48 --ref 6 --vbv-bufsize 2000 --deblock -2:-2 --me umh --overscan show --preset ultrafast --scenecut 40 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,None,--weightb,2.5,1.1,1.3,0.2,0.2,0.9,0.1,1,0,16,5,270,3,25,20,3,1,63,48,6,2000,-2:-2,umh,show,ultrafast,40,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"