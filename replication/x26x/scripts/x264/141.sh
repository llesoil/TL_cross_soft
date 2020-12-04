#!/bin/sh

numb='142'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --no-asm --slow-firstpass --no-weightb --aq-strength 1.0 --ipratio 1.4 --pbratio 1.1 --psy-rd 4.0 --qblur 0.6 --qcomp 0.7 --vbv-init 0.2 --aq-mode 3 --b-adapt 2 --bframes 10 --crf 0 --keyint 200 --lookahead-threads 0 --min-keyint 21 --qp 30 --qpstep 4 --qpmin 0 --qpmax 68 --rc-lookahead 28 --ref 6 --vbv-bufsize 1000 --deblock -1:-1 --me umh --overscan crop --preset superfast --scenecut 10 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,--slow-firstpass,--no-weightb,1.0,1.4,1.1,4.0,0.6,0.7,0.2,3,2,10,0,200,0,21,30,4,0,68,28,6,1000,-1:-1,umh,crop,superfast,10,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"