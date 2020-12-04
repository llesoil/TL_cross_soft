#!/bin/sh

numb='1475'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --no-asm --no-weightb --aq-strength 0.0 --ipratio 1.2 --pbratio 1.3 --psy-rd 3.0 --qblur 0.5 --qcomp 0.6 --vbv-init 0.2 --aq-mode 1 --b-adapt 2 --bframes 0 --crf 15 --keyint 300 --lookahead-threads 4 --min-keyint 22 --qp 20 --qpstep 4 --qpmin 2 --qpmax 61 --rc-lookahead 48 --ref 1 --vbv-bufsize 1000 --deblock -1:-1 --me umh --overscan crop --preset superfast --scenecut 30 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,None,--no-weightb,0.0,1.2,1.3,3.0,0.5,0.6,0.2,1,2,0,15,300,4,22,20,4,2,61,48,1,1000,-1:-1,umh,crop,superfast,30,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"