#!/bin/sh

numb='1974'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --no-asm --weightb --aq-strength 3.0 --ipratio 1.2 --pbratio 1.3 --psy-rd 3.8 --qblur 0.4 --qcomp 0.7 --vbv-init 0.1 --aq-mode 0 --b-adapt 0 --bframes 4 --crf 35 --keyint 230 --lookahead-threads 1 --min-keyint 30 --qp 50 --qpstep 5 --qpmin 4 --qpmax 64 --rc-lookahead 48 --ref 6 --vbv-bufsize 2000 --deblock -1:-1 --me dia --overscan crop --preset slower --scenecut 0 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,None,--weightb,3.0,1.2,1.3,3.8,0.4,0.7,0.1,0,0,4,35,230,1,30,50,5,4,64,48,6,2000,-1:-1,dia,crop,slower,0,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"