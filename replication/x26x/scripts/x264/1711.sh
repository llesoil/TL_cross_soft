#!/bin/sh

numb='1712'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --no-asm --no-weightb --aq-strength 3.0 --ipratio 1.0 --pbratio 1.0 --psy-rd 2.8 --qblur 0.5 --qcomp 0.7 --vbv-init 0.4 --aq-mode 3 --b-adapt 1 --bframes 6 --crf 15 --keyint 300 --lookahead-threads 1 --min-keyint 23 --qp 50 --qpstep 4 --qpmin 2 --qpmax 69 --rc-lookahead 48 --ref 3 --vbv-bufsize 2000 --deblock -1:-1 --me umh --overscan show --preset ultrafast --scenecut 40 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,None,--no-weightb,3.0,1.0,1.0,2.8,0.5,0.7,0.4,3,1,6,15,300,1,23,50,4,2,69,48,3,2000,-1:-1,umh,show,ultrafast,40,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"