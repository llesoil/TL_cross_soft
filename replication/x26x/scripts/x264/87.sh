#!/bin/sh

numb='88'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --no-weightb --aq-strength 2.0 --ipratio 1.1 --pbratio 1.3 --psy-rd 2.2 --qblur 0.6 --qcomp 0.9 --vbv-init 0.7 --aq-mode 0 --b-adapt 2 --bframes 6 --crf 50 --keyint 230 --lookahead-threads 0 --min-keyint 26 --qp 50 --qpstep 4 --qpmin 1 --qpmax 67 --rc-lookahead 48 --ref 1 --vbv-bufsize 1000 --deblock -1:-1 --me hex --overscan show --preset ultrafast --scenecut 0 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,None,--no-weightb,2.0,1.1,1.3,2.2,0.6,0.9,0.7,0,2,6,50,230,0,26,50,4,1,67,48,1,1000,-1:-1,hex,show,ultrafast,0,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"