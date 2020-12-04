#!/bin/sh

numb='2247'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --no-asm --no-weightb --aq-strength 1.5 --ipratio 1.0 --pbratio 1.1 --psy-rd 3.0 --qblur 0.5 --qcomp 0.9 --vbv-init 0.9 --aq-mode 3 --b-adapt 0 --bframes 14 --crf 20 --keyint 290 --lookahead-threads 1 --min-keyint 20 --qp 50 --qpstep 5 --qpmin 0 --qpmax 63 --rc-lookahead 28 --ref 6 --vbv-bufsize 2000 --deblock 1:1 --me umh --overscan show --preset ultrafast --scenecut 0 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,None,--no-weightb,1.5,1.0,1.1,3.0,0.5,0.9,0.9,3,0,14,20,290,1,20,50,5,0,63,28,6,2000,1:1,umh,show,ultrafast,0,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"