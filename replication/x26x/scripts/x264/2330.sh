#!/bin/sh

numb='2331'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --no-asm --no-weightb --aq-strength 1.0 --ipratio 1.6 --pbratio 1.3 --psy-rd 1.2 --qblur 0.6 --qcomp 0.6 --vbv-init 0.8 --aq-mode 3 --b-adapt 0 --bframes 16 --crf 5 --keyint 210 --lookahead-threads 4 --min-keyint 20 --qp 10 --qpstep 3 --qpmin 2 --qpmax 61 --rc-lookahead 38 --ref 1 --vbv-bufsize 2000 --deblock -2:-2 --me umh --overscan show --preset slower --scenecut 40 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,None,--no-weightb,1.0,1.6,1.3,1.2,0.6,0.6,0.8,3,0,16,5,210,4,20,10,3,2,61,38,1,2000,-2:-2,umh,show,slower,40,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"