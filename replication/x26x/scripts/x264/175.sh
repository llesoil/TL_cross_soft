#!/bin/sh

numb='176'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --slow-firstpass --no-weightb --aq-strength 3.0 --ipratio 1.1 --pbratio 1.1 --psy-rd 0.6 --qblur 0.3 --qcomp 0.7 --vbv-init 0.4 --aq-mode 0 --b-adapt 0 --bframes 16 --crf 40 --keyint 230 --lookahead-threads 2 --min-keyint 28 --qp 20 --qpstep 4 --qpmin 3 --qpmax 69 --rc-lookahead 48 --ref 6 --vbv-bufsize 1000 --deblock -1:-1 --me umh --overscan show --preset veryfast --scenecut 10 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,--slow-firstpass,--no-weightb,3.0,1.1,1.1,0.6,0.3,0.7,0.4,0,0,16,40,230,2,28,20,4,3,69,48,6,1000,-1:-1,umh,show,veryfast,10,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"