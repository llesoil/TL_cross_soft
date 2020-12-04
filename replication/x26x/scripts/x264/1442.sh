#!/bin/sh

numb='1443'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --weightb --aq-strength 0.5 --ipratio 1.2 --pbratio 1.0 --psy-rd 2.6 --qblur 0.6 --qcomp 0.7 --vbv-init 0.4 --aq-mode 2 --b-adapt 2 --bframes 12 --crf 35 --keyint 280 --lookahead-threads 3 --min-keyint 29 --qp 20 --qpstep 3 --qpmin 4 --qpmax 67 --rc-lookahead 28 --ref 3 --vbv-bufsize 1000 --deblock -2:-2 --me umh --overscan show --preset ultrafast --scenecut 10 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,None,--weightb,0.5,1.2,1.0,2.6,0.6,0.7,0.4,2,2,12,35,280,3,29,20,3,4,67,28,3,1000,-2:-2,umh,show,ultrafast,10,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"