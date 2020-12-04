#!/bin/sh

numb='1306'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --no-asm --no-weightb --aq-strength 3.0 --ipratio 1.5 --pbratio 1.3 --psy-rd 1.6 --qblur 0.2 --qcomp 0.9 --vbv-init 0.3 --aq-mode 2 --b-adapt 1 --bframes 8 --crf 50 --keyint 250 --lookahead-threads 3 --min-keyint 22 --qp 40 --qpstep 3 --qpmin 0 --qpmax 65 --rc-lookahead 38 --ref 1 --vbv-bufsize 1000 --deblock -1:-1 --me hex --overscan show --preset ultrafast --scenecut 40 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,None,--no-weightb,3.0,1.5,1.3,1.6,0.2,0.9,0.3,2,1,8,50,250,3,22,40,3,0,65,38,1,1000,-1:-1,hex,show,ultrafast,40,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"