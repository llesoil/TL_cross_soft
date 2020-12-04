#!/bin/sh

numb='708'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --no-asm --slow-firstpass --no-weightb --aq-strength 2.0 --ipratio 1.0 --pbratio 1.1 --psy-rd 1.2 --qblur 0.6 --qcomp 0.6 --vbv-init 0.2 --aq-mode 0 --b-adapt 1 --bframes 16 --crf 10 --keyint 230 --lookahead-threads 4 --min-keyint 25 --qp 10 --qpstep 5 --qpmin 0 --qpmax 64 --rc-lookahead 18 --ref 6 --vbv-bufsize 2000 --deblock 1:1 --me dia --overscan crop --preset superfast --scenecut 10 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,--slow-firstpass,--no-weightb,2.0,1.0,1.1,1.2,0.6,0.6,0.2,0,1,16,10,230,4,25,10,5,0,64,18,6,2000,1:1,dia,crop,superfast,10,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"