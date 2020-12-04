#!/bin/sh

numb='2074'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --weightb --aq-strength 3.0 --ipratio 1.1 --pbratio 1.1 --psy-rd 4.6 --qblur 0.4 --qcomp 0.7 --vbv-init 0.7 --aq-mode 3 --b-adapt 1 --bframes 14 --crf 0 --keyint 230 --lookahead-threads 0 --min-keyint 26 --qp 30 --qpstep 4 --qpmin 1 --qpmax 65 --rc-lookahead 18 --ref 6 --vbv-bufsize 1000 --deblock -1:-1 --me hex --overscan show --preset ultrafast --scenecut 0 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,None,--weightb,3.0,1.1,1.1,4.6,0.4,0.7,0.7,3,1,14,0,230,0,26,30,4,1,65,18,6,1000,-1:-1,hex,show,ultrafast,0,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"