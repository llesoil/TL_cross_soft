#!/bin/sh

numb='2158'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --no-asm --no-weightb --aq-strength 1.5 --ipratio 1.0 --pbratio 1.2 --psy-rd 1.6 --qblur 0.4 --qcomp 0.9 --vbv-init 0.5 --aq-mode 1 --b-adapt 0 --bframes 10 --crf 10 --keyint 280 --lookahead-threads 4 --min-keyint 23 --qp 10 --qpstep 5 --qpmin 0 --qpmax 61 --rc-lookahead 48 --ref 1 --vbv-bufsize 1000 --deblock -1:-1 --me umh --overscan show --preset ultrafast --scenecut 30 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,None,--no-weightb,1.5,1.0,1.2,1.6,0.4,0.9,0.5,1,0,10,10,280,4,23,10,5,0,61,48,1,1000,-1:-1,umh,show,ultrafast,30,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"