#!/bin/sh

numb='2830'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --slow-firstpass --no-weightb --aq-strength 1.0 --ipratio 1.0 --pbratio 1.4 --psy-rd 2.8 --qblur 0.5 --qcomp 0.7 --vbv-init 0.1 --aq-mode 2 --b-adapt 2 --bframes 0 --crf 40 --keyint 230 --lookahead-threads 1 --min-keyint 20 --qp 0 --qpstep 5 --qpmin 1 --qpmax 67 --rc-lookahead 18 --ref 1 --vbv-bufsize 2000 --deblock -2:-2 --me umh --overscan crop --preset ultrafast --scenecut 40 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,--slow-firstpass,--no-weightb,1.0,1.0,1.4,2.8,0.5,0.7,0.1,2,2,0,40,230,1,20,0,5,1,67,18,1,2000,-2:-2,umh,crop,ultrafast,40,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"