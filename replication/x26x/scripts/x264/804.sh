#!/bin/sh

numb='805'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --no-asm --no-weightb --aq-strength 3.0 --ipratio 1.1 --pbratio 1.3 --psy-rd 4.0 --qblur 0.4 --qcomp 0.8 --vbv-init 0.8 --aq-mode 2 --b-adapt 2 --bframes 16 --crf 20 --keyint 280 --lookahead-threads 3 --min-keyint 23 --qp 50 --qpstep 5 --qpmin 4 --qpmax 61 --rc-lookahead 38 --ref 4 --vbv-bufsize 1000 --deblock 1:1 --me hex --overscan show --preset ultrafast --scenecut 10 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,None,--no-weightb,3.0,1.1,1.3,4.0,0.4,0.8,0.8,2,2,16,20,280,3,23,50,5,4,61,38,4,1000,1:1,hex,show,ultrafast,10,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"