#!/bin/sh

numb='3099'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --weightb --aq-strength 2.5 --ipratio 1.6 --pbratio 1.4 --psy-rd 0.2 --qblur 0.2 --qcomp 0.9 --vbv-init 0.0 --aq-mode 3 --b-adapt 2 --bframes 0 --crf 25 --keyint 270 --lookahead-threads 2 --min-keyint 22 --qp 20 --qpstep 3 --qpmin 4 --qpmax 61 --rc-lookahead 48 --ref 1 --vbv-bufsize 2000 --deblock -2:-2 --me hex --overscan show --preset ultrafast --scenecut 10 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,None,--weightb,2.5,1.6,1.4,0.2,0.2,0.9,0.0,3,2,0,25,270,2,22,20,3,4,61,48,1,2000,-2:-2,hex,show,ultrafast,10,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"